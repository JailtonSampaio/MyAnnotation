module RailsAdminReportPdf
end

require 'prawn'
require 'gruff'

module RailsAdmin
  module Config
    module Actions
      class ReportPdf < RailsAdmin::Config::Actions::Base

        register_instance_option :collection? do
           true
        end

        register_instance_option :route_fragment do
          'report_pdf'
        end

        register_instance_option :http_methods do
          [:get,:post]
        end

        register_instance_option :controller do
          Proc.new do

            if request.get?
              #  flash.now[:notice] = "get successful"
              render @action.template_name, layout: true

            elsif request.post?

              #recebendo os parametros do form post --- range de data e usuarios ----
              frm_date = { :ini => params[:data_busca].at(0..9).to_date, :fim => params[:data_busca].at(13..22).to_date}
              if params[:frm_users] == ''
                frm_users = []
                User.select('id').where("status = 0 AND kind = 2 OR status = 0 AND kind = 1 OR status = 0 AND kind = 0").each do |us|
                  frm_users << us.id
                end

              else
                frm_users = JSON.parse("[0#{params[:frm_users]}]")
                flash.now[:notice] = "#{frm_users} oi"
              end

              # Configurando PDF

              PDF_OPTIONS = { :page_size => "A4",:page_layout => :portrait, :margin => [40, 75] }

              # Configurando Retorno
              ramdom_file_name = (0...8).map { (65 + rand(26)).chr }.join
              Prawn::Document.new(PDF_OPTIONS) do |pdf|
                pdf.font "Helvetica"
                pdf.fill_color "000000"
                pdf.text "Produtividade dos Usuários", :size => 16, :style => :bold, :align => :center
                pdf.move_down 10
                pdf.fill_color "666666"
                pdf.text "Periodo #{frm_date[:ini]} à #{frm_date[:fim]}", :size => 14, :style => :bold, :align => :right
                pdf.stroke_horizontal_rule
                pdf.move_down 20

              #variaveis de contagem de anotações e a soma dos caracteres das anotações e tabela
              anno_total = 0
              anno_caract = 0
              tabela_user = []
              tabela_user << ["Nome","Anotações","caracteres"]


              frm_users.each do |us|
                if us > 0
                  #Contagem das anotações e a soma dos caracteres das anotações
                  Annotation.where(:user_id => us , :date => frm_date[:ini]..frm_date[:fim]).each do |an|
                    anno_total = anno_total + 1
                    anno_caract = an.notes.length
                  end
                  #icluido o que vai ser exibido no PDF
                  idname = User.select('id','name').find(us)
                  #incremento da array para criar tabela no prawn
                  tabela_user << [idname.name,anno_total.to_s,anno_caract.to_s]



                    #pdf.fill_color "000000"


                  #----Zerando contagem para proximo usuario
                  anno_caract = 0
                  anno_total = 0

                end

              end
              #pdf.table [[Prawn::Table::Cell::Text.new( pdf, [0,0], :content => "Title", :align => :center, :inline_format => true, :size => 12)], tabela_user]
              pdf.table(tabela_user, [0,0], :content => "Title",:inline_format => true, :size => 12)
              pdf.render_file File.join(Rails.root, "public/pdfs", "#{ramdom_file_name}.pdf")

              File.open("#{Rails.root}/public/pdfs/#{ramdom_file_name}.pdf", 'r') do |f|
                send_data f.read.force_encoding('BINARY'), :filename => "#{params[:periodo]}dias_#{Date.current}.pdf", :type => "application/pdf", :disposition => "attachment"
              end

              end #do pdf

              File.delete("#{Rails.root}/public/pdfs/#{ramdom_file_name}.pdf")


            end # elsif post

          end

        end


        register_instance_option :pjax? do
          false
        end


        register_instance_option :link_icon do
          'fa fa-file-pdf-o'
        end
      end
    end
  end
end

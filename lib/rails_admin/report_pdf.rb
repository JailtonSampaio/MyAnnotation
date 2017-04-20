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
              #frm_date = { :ini => params[:data_busca].at(0..9).to_date, :fim => params[:data_busca].at(13..22).to_date}
              frm_data_ini = params[:data_busca].at(0..9).to_date
              frm_data_fim = params[:data_busca].at(13..22).to_date
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

                pdf.repeat :all do
                  # header

                  pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], :width  => pdf.bounds.width do
                    pdf.image "./public/logo.png", :align => :left, :width => 100
                    pdf.fill_color "000000"
                    pdf.text "Produtividade dos Usuários", :size => 16, :style => :bold, :align => :center
                    pdf.move_down 10
                    pdf.fill_color "666666"
                    pdf.text "Período #{frm_data_ini.strftime("%d/%m/%Y")} à #{frm_data_fim.strftime("%d/%m/%Y")}", :size => 12, :style => :bold, :align => :right
                    pdf.fill_color "000000"
                    pdf.stroke_horizontal_rule
                    pdf.move_down 10
                  end


                  # footer
                  # Inclui em baixo da folha do lado direito a data e hora
                  pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 10], :width  => pdf.bounds.width do
                    #pdf.stroke_horizontal_rule
                    #pdf.number_pages "Desenvolvido por JK Soluções - Gerado em: #{(Time.now).strftime("%d/%m/%Y as %H:%M")} - Pagina <page> de <total>", { :start_count_at => 0, :page_filter => :all, :align => :right, :size => 14 }
                    #pag =  pdf.page_count
                    pdf.text "Desenvolvido por JK Soluções - Gerado em: #{(Time.now).strftime("%d/%m/%Y as %H:%M")}", :size => 8, :align => :right
                  end
                  #pdf.number_pages "Gerado: #{(Time.now).strftime("%d/%m/%y as %H:%M")} - Página ", :start_count_at => 0, :page_filter => :all, :size => 8 , :at => [140, 7]


                end


                pdf.font "Helvetica"


              #variaveis de contagem de anotações e a soma dos caracteres das anotações e tabela
              anno_total = 0
              anno_caract = 0
              tabela_user = []
              tabela_user << ["Nome dos Usuários","Anotações","Caracteres"]
              total_geral_anota = 0
              total_geral_caract = 0

              frm_users.each do |us|
                if us > 0
                  #seleciona o usuario
                  idname = User.select('id','name').find(us)
                  #Contagem das anotações e a soma dos caracteres das anotações de cada usuario
                  Annotation.where(:user_id => us, :date => frm_data_ini..frm_data_fim).each do |an|
                    anno_total = anno_total + 1
                    anno_caract = an.notes.length
                  end
                  #incremento da array para criar tabela no prawn usuario , total de anotações e caracteres no preriodo
                  tabela_user << [idname.name,anno_total.to_s,anno_caract.to_s]
                  #total geral de anotações e caracteres
                  total_geral_anota = total_geral_anota + anno_total
                  total_geral_caract = total_geral_caract + anno_caract
                  #pdf.fill_color "000000"

                  #----Zerando contagem para proximo usuario
                  anno_caract = 0
                  anno_total = 0

                end

              end

              #controles para gerar o grafico
              graf_dates = []
              frm_data_ini.upto(frm_data_fim) do |dat|
                graf_dates << dat
              end
              graf_dados = []
              graf_users = []
              graf_dados = []
              graf_dados_cont = []
              frm_users.each do |us|
                if us > 0
                  idname = User.select('id','name').find(us)
                  graf_users << idname.name

                  graf_dates.each do |dt|

                    dt = Annotation.where(:user_id => us, :date => dt).count
                      if dt == ''
                        graf_dados_cont << 0
                      else
                        graf_dados_cont << dt
                      end

                  end
                  graf_dados << graf_dados_cont
                  graf_dados_cont = []

                end
              end


              #body
              pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 80], :width  => pdf.bounds.width, :height => pdf.bounds.height - 100) do
                #pdf.table [[Prawn::Table::Cell::Text.new( pdf, [0,0], :content => "Title", :align => :center, :inline_format => true, :size => 12)], tabela_user]
                pdf.table tabela_user, :row_colors => ["F0F0F0", "FFFFCC"], :position => :center,  :column_widths => [300, 60, 60], :cell_style => { :size => 10 }
                pdf.move_down 10
                pdf.text "Total geral: Anotações = #{total_geral_anota} Caracteres = #{total_geral_caract}", :size => 12, :align => :right


                #nova pagina
                #criando grafico com o Gruff
                pdf.start_new_page
                pdf.move_down 20
                g = Gruff::Line.new(900)
                g.title = "Anotações Diárias"
                g.theme_37signals

                # sales data:
                graf_users.each_with_index do |ud,k|
                  g.data("#{ud}",graf_dados[k])
                end


                # month labels:
                #key = Hash[*graf_dates.collect { |v| [graf_dates.index(v),v.strftime("%d/%m").to_s]}.flatten]
                #g.labels = key

                #oculta a legenda
                #g.hide_legend = true

                g.y_axis_label = 'Anotações'
                g.x_axis_label = "Período #{frm_data_ini.strftime("%d/%m/%Y")} à #{frm_data_fim.strftime("%d/%m/%Y")}"

                #g.replace_colors(['red','blue','black'])



                g.write("public/pdfs/#{ramdom_file_name}.jpg")
                pdf.image "public/pdfs/#{ramdom_file_name}.jpg", :scale => 0.50

              end


              #inserindo numero de paginas
               pdf.number_pages "Página <page> de <total>", :at => [0, 10], :size => 10

              pdf.render_file File.join(Rails.root, "public/pdfs", "#{ramdom_file_name}.pdf")
              File.open("#{Rails.root}/public/pdfs/#{ramdom_file_name}.pdf", 'r') do |f|
                send_data f.read.force_encoding('BINARY'), :filename => "#{params[:periodo]}dias_#{Date.current}.pdf", :type => "application/pdf", :disposition => "attachment"
              end

              end #do pdf

              File.delete("#{Rails.root}/public/pdfs/#{ramdom_file_name}.pdf")
              File.delete("#{Rails.root}/public/pdfs/#{ramdom_file_name}.jpg")

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

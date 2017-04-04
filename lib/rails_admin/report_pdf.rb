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
              flash.now[:notice] = "get successful"
              render @action.template_name, layout: true


            elsif request.post?
              # Configurando PDF

                PDF_OPTIONS = { :page_size => "A4",
                      :page_layout => :portrait,
                      :margin      => [40, 75]
                    }

                    # Configurando Retorno
                    ramdom_file_name = (0...8).map { (65 + rand(26)).chr }.join
                    Prawn::Document.new(PDF_OPTIONS) do |pdf|
                      pdf.fill_color "666666"
                      pdf.text "Produtividade dos Usuários", :size => 32, :style => :bold, :align => :center
                      pdf.move_down 80
                      User.find_each do |u|
                        c = u.name.length
                        pdf.text "Nome: #{u.name} / #{c}", :size => 14, :style => :bold, :align => :center
                        pdf.move_down 8
                      end


                      g = Gruff::Line.new
                      g.title = 'Desempenho'
                      g.labels = { 0 => '30 dias', }
                      g.data :Jailton, [5, 1, 5, 0, 3, 4, 2, 5]
                      g.data :Karina, [80, 54, 67, 54, 68, 70, 90, 95]
                      g.data :carivaldo, [22, 29, 35, 38, 36, 40, 46, 57]
                      g.data :teste, [95, 95, 95, 90, 85, 80, 88, 100]


                      g.write("public/pdfs/#{ramdom_file_name}.jpg")
                      pdf.image "public/pdfs/#{ramdom_file_name}.jpg", :scale => 0.50

                      pdf.render_file File.join(Rails.root, "public/pdfs", "#{ramdom_file_name}.pdf")

                      File.open("#{Rails.root}/public/pdfs/#{ramdom_file_name}.pdf", 'r') do |f|
                        send_data f.read.force_encoding('BINARY'), :filename => "#{params[:periodo]}dias_#{Date.current}.pdf", :type => "application/pdf", :disposition => "attachment"
                      end

                    end
                    File.delete("#{Rails.root}/public/pdfs/#{ramdom_file_name}.pdf")
                    File.delete("#{Rails.root}/public/pdfs/#{ramdom_file_name}.jpg")
            end

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

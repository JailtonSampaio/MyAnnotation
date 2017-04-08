module RailsAdminGraficChartKick
end

module RailsAdmin
  module Config
    module Actions
      class GraficChartKick < RailsAdmin::Config::Actions::Base

        register_instance_option :collection? do
           true
        end

        register_instance_option :route_fragment do
          'GraficChart'
        end

        register_instance_option :http_methods do
          [:get,:post]
        end

        register_instance_option :controller do
          Proc.new do
            if request.get?
              #flash.now[:notice] = "get successful"
              render @action.template_name, layout: true


            elsif request.post?
              # Configurando PDF


            end

          end

        end


        register_instance_option :pjax? do
          false
        end


        register_instance_option :link_icon do
          'fa fa-line-chart'
        end
      end
    end
  end
end

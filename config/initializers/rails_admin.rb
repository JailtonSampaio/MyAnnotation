RailsAdmin.config do |config|

  #Incluindo as Custom Actions

  require Rails.root.join('lib', 'rails_admin', 'report_pdf.rb')
  RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::ReportPdf)


  require Rails.root.join('lib', 'rails_admin', 'grafic_chart_kick.rb')
  RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::GraficChartKick)


  ### Popular gems integration
  ## == Devise ==
  config.authenticate_with do
     warden.authenticate! scope: :user
   end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  #config.show_gravatar true



  config.actions do

    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete

    report_pdf do

        only Annotation
      #  my_option :journalist => false

    end

    grafic_chart_kick do

        only Annotation
      #  my_option :journalist => false

    end



    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

#Configurando historico

#config.audit_with :history, Annotation

#Inicio das configurações de listagem editar e criar

  config.model Annotation do
    #incluindo icone do http://fontawesome.io/icon
    #navigation_icon "fa-text-width"
    configure :notes do
      html_attributes rows: 20, cols: 50
      required true
    end
    create do
      field  :title
      field  :notes


      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id
        end
      end

      field :date, :hidden do
        default_value do Date.current
        end
      end

      field :status, :hidden do
        default_value do "active"

        end
      end

    end

      edit do
        field  :title
        field  :notes

        #field.disabled :user_id
        #field.disabled :date

        field :status
      end

  end


  config.model User do

    visible do

      #Testa se o usuario é manager borlean
      bindings[:controller]._current_user.kind == "super" or bindings[:controller]._current_user.kind == "manager"

    end
    create do
      field  :name
      field  :kind
      field  :status
      field  :email
      field  :password
      field  :password_confirmation


    end

      edit do

        field  :status
        #field  :photo

        field  :password
        field  :password_confirmation

      end

  end


#Modificando a aparencia

    #mudando o nome da aplicação
      config.main_app_name = "My Annotation", "*Minhas Anotações*"


    #recria a barra de navegação da direita e inclua no Application_Controller.rb
    #RailsAdmin::ApplicationHelper.module_eval do

      #def main_navigation
      #  nodes_stack = RailsAdmin::Config.visible_models(controller: controller)
      #  node_model_names = nodes_stack.collect { |c| c.abstract_model.model_name }

      #  nodes_stack.group_by(&:navigation_label).collect do |navigation_label, nodes|
      #    nodes = nodes.select { |n| n.parent.nil? || !n.parent.to_s.in?(node_model_names) }
      #    li_stack = navigation nodes_stack, nodes

      #    label = navigation_label || t("admin.misc.navigation")

          #inclui link na barra de navegação sem aparecer no grupo link no final da espa
           # + "<li data-model=\"_\"><a class=\"pjax\" href=\"/report/pdf\">Relatórios</a></li>"

      #   %("<li class='dropdown-header'> #{capitalize_first_letter label}</li>#{li_stack}") if li_stack.present?

      #  end.join.html_safe

      #end
    #end






end

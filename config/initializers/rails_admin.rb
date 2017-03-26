RailsAdmin.config do |config|

  #require 'query_report/helper'

  #Abilitando e exibindo a acition

  #require Rails.root.join('lib', 'rails_admin', 'rails_admin_pdf.rb')
  #RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::Pdf)


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

  require 'rails_admin/config/actions/launch_filter'

  RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::LaunchFilter)

  config.actions do
    launch_filter { only Filter }
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    #indicando em qual model vai ser vinculado a acition
    #show_in_app
    #pdf do
    #  only User
    #end

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

# recria a lista de  de navegação coloca todos os models e inclui um link personalizado no final
  RailsAdmin::ApplicationHelper.module_eval do

    def main_navigation
      nodes_stack = RailsAdmin::Config.visible_models(controller: controller)
      node_model_names = nodes_stack.collect { |c| c.abstract_model.model_name }

      nodes_stack.group_by(&:navigation_label).collect do |navigation_label, nodes|
        nodes = nodes.select { |n| n.parent.nil? || !n.parent.to_s.in?(node_model_names) }
        li_stack = navigation nodes_stack, nodes

        label = navigation_label || t('admin.misc.navigation')

        %(<li class='dropdown-header'></li>#{li_stack}<li data-model=\"_\"><a class=\"pjax\" href=\"/report/pdf\">Relatorios</a>) if li_stack.present?
      end.join.html_safe

    end
  end


#Configurando historico

#config.audit_with :history, Annotation

#Inicio das configurações de listagem editar e criar

  config.model Annotation do
    #incluindo icone do http://fontawesome.io/icon
    #navigation_icon "fa-text-width"
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
    create do
      field  :name
      field  :kind
      field  :status
      field  :email
      field  :password
      field  :password_confirmation


    end

      edit do


        field  :photo

        field  :password
        field  :password_confirmation

      end

  end


#Modificando a aparencia

    #mudando o nome da aplicação
      config.main_app_name = "My Annotation", "*Minhas Anotações*"

#abilitandi graficos no models
#  include RailsAdminCharts
#  config.actions do
#   all # NB: comment out this line for RailsAdmin < 0.6.0
#   charts

#      class Annotation < ActiveRecord::Base
#          def self.graph_data(since = -30.days.ago)
#          end
#          def self.chart_type
#            'charts'
#          end
#      end

#    end





end

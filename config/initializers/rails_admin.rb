RailsAdmin.config do |config|

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
  # config.show_gravatar true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

#Inicio das configurações de listagem editar e criar

  config.model Annotation do
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
  end

  config.model Annotation do
    edit do
      field  :title
      field  :notes

      #field.disabled :user_id
      #field.disabled :date

      field :status
    end
  end







end

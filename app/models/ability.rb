


#---informações sobre ações de cada kind tipo de usuarios
#------kind: journalist
#---------- cria e edita suas anotações, ler e editar seu usuario
#------kind: portal
#---------- cria e edita suas anotações, ler e editar seu usuario
#------kind: pagination
#---------- ler todas as anotações, ler e editar seu usuario
#------kind: editor
#---------- cria e edita todas as anotações, ler e editar seu usuario
#------kind: manager
#---------- ler e edita o estatos de suas anotações, criar ler e editar todos usuarios
#------kind: super
#---------- todas as funções
#--------------------------------------------------------------------

class Ability
  include CanCan::Ability

  def initialize(user)
    if user
        u = user.kind
        case u
            when u = "journalist"
                can :access, :rails_admin
                can :dashboard
                can [:read,:create,:update], Annotation, user_id: user.id
                can [:read,:update], User, id: user.id

            when u = "pagination"
                can :access, :rails_admin
                can :dashboard
                can :read, Annotation, status: "active"
                can [:read,:update], User, id: user.id
                can :pagination, Annotation, :grafic_chart_kick => false

            when u = "manager"
                can :manage, :all
        end
    end



    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end

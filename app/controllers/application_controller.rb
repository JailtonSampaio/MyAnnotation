class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


#recria a barra de navegação da direita e
#corrige um problrma de visualização quando se volta do link Incluir tabme no rails initializers

  #RailsAdmin::ApplicationHelper.module_eval do
  #  def main_navigation
  #    nodes_stack = RailsAdmin::Config.visible_models(controller: controller)
  #    node_model_names = nodes_stack.collect { |c| c.abstract_model.model_name }

  #    nodes_stack.group_by(&:navigation_label).collect do |navigation_label, nodes|
  #      nodes = nodes.select { |n| n.parent.nil? || !n.parent.to_s.in?(node_model_names) }
  #      li_stack = navigation nodes_stack, nodes

  #      label = navigation_label || t("admin.misc.navigation")

          #inclui link na barra de navegação sem aparecer no grupo link incluir no final da aspa
          #  + "<li data-model=\"_\"><a class=\"pjax\" href=\"/report/pdf\">Relatórios</a></li>"

  #      %("<li class='dropdown-header'> #{capitalize_first_letter label}</li>#{li_stack}") if li_stack.present?

  #    end.join.html_safe

  #  end
  #end
end

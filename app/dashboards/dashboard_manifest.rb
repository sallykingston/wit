# DashboardManifest tells Administrate which dashboards to display
class DashboardManifest
  # `DASHBOARDS`
  # a list of dashboards to display in the side navigation menu
  #
  # To show or hide dashboards, add or remove the model name from this list.
  # Dashboards returned from this method must be Rails models for Administrate
  # to work correctly.
  DASHBOARDS = [
    :users,
    :articles,
    :boards,
    :topics
  ]

  # `ROOT_DASHBOARD`
  # the dashboard that will be displayed at "http://your_site.com/admin"
  ROOT_DASHBOARD = :articles
end

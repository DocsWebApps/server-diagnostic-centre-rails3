DiagnosticCentre::Application.routes.draw do

  resources :session
  root to: 'session#diagnostic_centre_signinpage' 
  match '/session/change_password', to: 'session#change_password'
  match '/session/add_user', to: 'session#add_user'
  match '/session/add_server', to: 'session#add_server'
  match '/SystemAnalyserHome', to: 'system_analyser#display_homepage'
  match '/SystemAnalyserHome/:server_id/', to: 'system_analyser#home_page_server_select'
  match '/SystemAnalyserServerMetrics/:server_id/:date', to: 'system_analyser#home_page_date_select'
  match '/SystemAnalyserProcessMetrics/:chart_type/:server_id/:date/:start_time/:end_time', to: 'system_analyser#server_metrics_range_select'
  match '/SystemAnalyserProcessMetrics/:process_id/:server_id/:date', to: 'system_analyser#allprocesses_metrics_process_select'
  match '/SystemAnalyserProcessMetrics/:process_id/:server_id/:start_time/:end_time', to: 'system_analyser#process_metrics_range_select'
  match '/SystemAnalyserProcessMetrics/:server_id/:date/:chart_type/:start_time/:end_time/:lower_value/:upper_value', to: 'system_analyser#allprocesses_metrics_range_select'
end

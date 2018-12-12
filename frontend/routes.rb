ArchivesSpace::Application.routes.draw do
  [AppConfig[:frontend_proxy_prefix], AppConfig[:frontend_prefix]].uniq.each do |prefix|
    scope prefix do
      match('/messages' => 'messages#index', :via => [:get])
      match('/messages/create' => 'messages#create', :via => [:post])
    end
  end
end

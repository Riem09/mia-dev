Mia::Application.routes.draw do

  namespace :api do
    resources :video_motifs
    resources :motifs do
      collection do
        get 'search' => 'motifs#search', :as => :search, :defaults => { :format => 'json' }
        get 'typeahead' => 'motifs#typeahead', :as => :typeahead, :defaults => { :format => 'json' }
        get 'random' => 'motifs#random', :as => :random, :defaults => { :format => 'json' }
      end
    end
    resources :video_uploads, :only => [:create, :show] do
      collection do
        post 'callback' => 'video_uploads#callback'
        post 'authorize' => 'video_uploads#authorize'
      end
    end
    resources :users, :only => [:show] do
      post 'authenticate' => 'users#authenticate', :on => :collection
      post 'reset' => 'users#reset', :on => :collection
    end
    resources :invites
    resources :videos
    resources :related_motifs, :only => [:create,:destroy], :defaults => { :format => 'json' }
    get 'search' => 'welcome#search', :as => :search
  end

end

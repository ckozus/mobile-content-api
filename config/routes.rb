# frozen_string_literal: true
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :systems, :auth, :translations, :drafts, :resources, :custom_pages, :languages, :attributes,
            :translated_attributes, :pages, :views, :attachments, :translated_pages

  get 'monitors/lb'
  get 'monitors/commit'

  get 'attachments/:id/download', to: 'attachments#download'

  put 'resources/:id/onesky', to: 'resources#push_to_onesky'

  mount Raddocs::App => '/docs'
end

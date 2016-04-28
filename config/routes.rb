Rails.application.routes.draw do

  resources :blog
  resources :homes

  root to: 'home#index'
  match 'login' => 'home#login_get', via: :get, as: 'login'
  match 'login' => 'home#login_post', via: :post, as: 'login_post'
  match 'logout' => 'home#logout', via: :delete, as: 'logout'
  match 'admin/blog/new' => 'admins#new_blog', via: :get
  match 'admin/blog' => 'admins#blog', via: :post
  match "admin/blog/:id/" => 'admins#destroy', via: :delete, as: 'delete_blog'
  match "admin/blog/:id/" => 'admins#edit', via: :put, as: 'blog_edit_put'
  match "admin/blog/:id/edit" => 'admins#edit_blog', via: :get, as: 'blog_edit'
  match 'blog' => 'blog#index', via: :get
  match 'blog/:id/comments' => 'blog#create_comment', via: :post, as: 'create_comment'
  match 'comment/:id' => 'blog#comment', via: :delete, as: 'delete_comment'
  match 'tag' => 'blog#tag_cloud', via: :get, as: 'tags'
  match 'tag/:name' => 'blog#tag', via: :get, as: 'tag'

end
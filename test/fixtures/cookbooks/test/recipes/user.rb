nodenv_user 'user-with-nodenv'

nodenv_install '14.21.3' do
  user 'user-with-nodenv'
end

nodenv_global '14.21.3' do
  user 'user-with-nodenv'
end

# Berksfile generated with https://github.com/afaundez/vagrant-templated
source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'test', path: 'test/fixtures/cookbooks/test'
end

cookbook(
  'node_build',
  '= 1.0.4',
  git: 'https://github.com/scholarsportal/node-build-cookbook.git',
  ref: 'c773d61637e82c27055f083e7b6a800bfe634b6d'
)

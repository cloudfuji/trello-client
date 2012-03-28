#!/usr/bin/env rake
require 'bundler/gem_tasks'

require 'rake/clean'
require 'rake/testtask'
require 'rdoc-readme/rake_task'
require 'rdoc/task'

%w{ coverage html out.txt pkg }.each { |p| CLEAN.include(p) }
%w{ build install rdoc test }.each   { |t| task t.to_sym => [ 'rdoc:readme' ] }

task :default => :test

Rake::TestTask.new do |t|
  t.libs       << 'test'
  t.test_files =   FileList['test/test*.rb']
  t.verbose    =   true
end

RDoc::Readme::RakeTask.new 'lib/trello-client.rb', 'README.rdoc'

RDoc::Task.new do |rdoc|
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc', 'lib/**/*.rb', 'doc/*.txt')
end

desc 'Update test data files'
task :update_test_data do
  $LOAD_PATH << 'lib'
  require 'open-uri'
  require 'trello-client'

  Trello::Client.new do |client|
    client.api_key    = ENV['TRELLO_API_KEY']
    client.api_token  = ENV['TRELLO_API_TOKEN']
    
    {
      'member'              => [ :member, 'me' ],
      'member_with_boards'  => [ :member, 'me', :boards => 'all' ]
    }.each_pair do |file, request|
      fn    = File.join( File.dirname(__FILE__), 'test', 'data', "#{file}.json" )
      meth  = request.shift
      args  = request
      File.open(fn, 'w') { |fh| fh.puts( client.send meth, *args ) }
    end
  end

end


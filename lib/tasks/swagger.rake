namespace :swagger do
  desc 'Creates swagger yml configuration file from erb template'
  task generate_docs: :environment do
    filepath = Rails.root.join('public', 'docs', 'api-docs.yml.erb')
    destination_filepath = Rails.root.join('public', 'docs', 'api-docs.yml')

    result  = ERB.new(File.read(filepath)).result
    file    = File.new(destination_filepath, 'w')

    file.write result
  end
end

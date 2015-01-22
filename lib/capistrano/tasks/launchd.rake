namespace :launchd do
  def launchd_dir
    @launchd_dir ||= Pathname.new('/Library/LaunchDaemons')
  end

  def plist_for(service)
    launchd_dir.join("org.mowoli.#{service}.plist")
  end

  def template(from, to)
    template_path = File.expand_path("../../templates/launchd/#{from}.plist.erb", __FILE__)
    template = ERB.new(File.new(template_path).read).result(binding)
    upload! StringIO.new(template), to

    execute :sudo, :chmod, "644 #{to}"
    execute :sudo, :chown, "root:wheel #{to}"
  end

  desc 'Setup Launch Daemons'
  task :setup do
    on roles(:app) do
      fetch(:services).each do |service|
        tmp_dir = Pathname.new('/tmp')
        tmp_filename = tmp_dir.join(File.basename(plist_for(service)))
        template service, tmp_filename
        execute :sudo, :mv, tmp_filename, plist_for(service)
      end
    end
  end

  desc 'Load Launch Daemons'
  task :load => :setup do
    on roles(:app) do
      fetch(:services).each do |service|
        execute :sudo, :launchctl, 'load -w', plist_for(service)
      end
    end
  end

  desc 'Unload Launch Daemons'
  task :unload => :setup do
    on roles(:app) do
      fetch(:services).each do |service|
        execute :sudo, :launchctl, 'unload -w', plist_for(service)
      end
    end
  end
end

metadata :name        => 'aptupdate',
         :description => 'Apt updating agent',
         :author      => 'Andy Sykes',
         :license     => 'GPLv2',
         :version     => '1.0',
         :url         => 'https://github.com/forward3d/mcollective-aptupdate-agent',
         :timeout     => 60

action 'update', :description => 'Run apt-get update on a specific repository or all repositories' do

    input :repository,
          :prompt      => 'Repository to run apt-get update on',
          :description => 'Repository to run apt-get update on',
          :type        => :string,
          :validation  => '.*',
          :optional    => true

    output :command_run,
           :description => 'Actual apt command run',
           :display_as  => 'Actual apt command run',
           :default     => ''
        
    output :stdout,
           :description => 'stdout from apt command',
           :display_as => 'stdout',
           :default => ''
           
    output :stderr,
           :description => 'stderr from apt command',
           :display_as => 'stderr',
           :default => ''

    output :exitcode,
           :description => 'Exitcode from apt command',
           :display_as => 'exitcode',
           :default => ''
  
end

action 'list', :description => "List all repositories available for update" do 

    output :repositories
           :description => 'Repositories',
           :display_as => 'Repositories',
           :default => ''
    
end
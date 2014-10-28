module MCollective
  module Agent
    class Aptupdate<RPC::Agent
      
      ALL_REPOSITORIES_COMMAND = "apt-get update"
      
      action "update" do
        
        apt_command = request[:repository].nil? ? 
          "apt-get update" :
          "apt-get update -o Dir::Etc::sourcelist='sources.list.d/#{request[:repository]}.list' -o Dir::Etc::sourceparts='-' -o APT::Get::List-Cleanup='0'"
          
        
        stdout = ""
        stderr = ""
        exitcode = run(
          apt_command, 
          :stdout => stdout,
          :stderr => stderr,
          :chomp => true
        )
        
        reply[:stdout] = stdout
        reply[:stderr] = stderr
        reply[:exitcode] = exitcode
        reply[:command_run] = command_run
        
        if exitcode != 0
          reply.fail! "Apt update failed"
        end
        
      end
      
      action "list" do
        reply[:repositories] = Dir.glob('/etc/apt/sources.list.d/*.list').map {|d| File.basename(d, '.list')}
      end
      
    end
  end
end
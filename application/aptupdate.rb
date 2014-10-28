module MCollective
  class Application
    class Aptupdate<MCollective::Application
      description "Run apt-get update on a specific repository or all repositories"

      usage <<-END_OF_USAGE
mco aptupdate <ACTION> [REPOSITORY]
Usage: mco aptupdate <ACTION> [REPOSITORY]

The ACTION can be one of the following:

    list    - List available repositories from /etc/apt/sources.list.d you can update
    update  - Run apt-get update

If no [REPOSITORY] argument is specified, the agent will run apt-get update for
every configured repository on the system. If you want to update only a single repository,
you can specify it like this:

    mco aptupdate update my_custom_repo
    
Use the list action to discover repositories you can update.
END_OF_USAGE

      def handle_message(action, message, *args)
        messages = {1 => 'Please specify an action',
                    2 => "Action has to be one of %s",
                    3 => "Do you really want to operate on packages unfiltered? (y/n): "}
        send(action, messages[message] % args)
      end

      def post_option_parser(configuration)
        
        if ARGV.size < 1
          handle_message(:raise, 1)
        end
        
        valid_actions = ['list', 'update']
        unless valid_actions.include?(ARGV[0])
          handle_message(:raise, 2, valid_actions)
        end
        
        configuration[:action] = ARGV[0]
        configuration[:repository] = ARGV[1] unless ARGV[1].nil? || ARGV[0] == 'list'

      end

      def main
        mc = rpcclient("aptupdate")
        
        responses = mc.list(:options => options)
        responses.each do |resp|
          printf("%-40s: %s\n", resp[:sender], resp[:data][:repositories].join(', '))
        end
        
        if configuration[:action] == 'update'
          if configuration[:repository].nil?
            printrpc mc.update(:options => options)
          else
            printrpc mc.update(:repository => configuration[:repository], :options => options)
          end
        end

        printrpcstats
        halt mc.stats
      end
    end
  end
end
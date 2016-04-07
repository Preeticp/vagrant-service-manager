module VagrantPlugins
  module GuestRedHat
    module Cap
      class BoxVersion
        # Prints the version of the vagrant box, parses /etc/os-release for version
        def self.box_version(machine, script_readable)
          command = "cat #{OS_RELEASE_FILE} | grep VARIANT"
          # TODO: execute efficient command to solve this
          if machine.communicate.test(command) # test if command is exits with code 0
            machine.communicate.execute(command) do |type, data|
              if type == :stderr
                @env.ui.error(data)
                exit 126
              end

              return data.chomp if script_readable
              info = Hash[data.delete('"').split("\n").map { |e| e.split('=') }]
              return "#{info['VARIANT']} #{info['VARIANT_VERSION']}"
            end
          end
        end
      end
    end
  end
end

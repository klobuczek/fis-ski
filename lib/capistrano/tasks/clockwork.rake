namespace :clockwork do
  [:stop, :start, :restart].each do |action|
    desc "#{action.to_s.capitalize}"
    task action do
      on roles(:worker) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :bundle, :exec, :clockworkd, "-c lib/clock.rb --pid-dir=#{shared_path}/tmp/pids --log-dir=#{shared_path}/log --log #{action}"
          end
        end
      end
    end
  end
end
module ThreeScale
  module SidekiqLogging
    def job_hash_context(job_hash)
      binding.pry # if job_hash['wrapped'] == "CronJob::Enqueuer"
      "#{super}#{filtered_args(job_hash)}"
    end

    private

    def filtered_args(job_hash)
      args = job_hash["wrapped"] ? job_hash["args"]&.first&.fetch("arguments", nil) : job_hash["args"]

      " #{FilterArguments.new(args).filter}" if args
    end
  end
end

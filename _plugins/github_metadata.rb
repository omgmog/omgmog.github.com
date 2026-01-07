require 'open3'

module Jekyll
  class GitHubMetadata < Generator
    safe true
    priority :highest

    def generate(site)
      github = {}

      # Extract repository info
      if ENV['GITHUB_REPOSITORY']
        # Running in GitHub Actions
        owner, repo = ENV['GITHUB_REPOSITORY'].split('/')
        github['owner_name'] = owner
        github['repository_name'] = repo
        github['repository_url'] = "https://github.com/#{ENV['GITHUB_REPOSITORY']}"
        github['issues_url'] = "https://github.com/#{ENV['GITHUB_REPOSITORY']}/issues"

        # Use GitHub SHA or custom revision
        github['build_revision'] = ENV['GITHUB_SHA'] || ENV['BUILD_REVISION'] || get_git_revision
      else
        # Local development - extract from Git
        remote_url = get_git_remote_url

        if remote_url =~ /github\.com[\/:](.+?)\/(.+?)(\.git)?$/
          github['owner_name'] = $1
          github['repository_name'] = $2
          github['repository_url'] = "https://github.com/#{$1}/#{$2}"
          github['issues_url'] = "https://github.com/#{$1}/#{$2}/issues"
        else
          # Fallback values for local dev without git remote
          github['owner_name'] = 'omgmog'
          github['repository_name'] = 'omgmog.github.com'
          github['repository_url'] = 'https://github.com/omgmog/omgmog.github.com'
          github['issues_url'] = 'https://github.com/omgmog/omgmog.github.com/issues'
        end

        github['build_revision'] = get_git_revision
      end

      # Store in site config
      site.config['github'] = github

      Jekyll.logger.info "GitHub Metadata:", "Loaded for #{github['owner_name']}/#{github['repository_name']}"
      Jekyll.logger.info "GitHub Metadata:", "Build revision: #{github['build_revision'][0..7]}"
    end

    private

    def get_git_revision
      stdout, stderr, status = Open3.capture3('git', 'rev-parse', 'HEAD')
      status.success? ? stdout.strip : 'unknown'
    rescue
      'unknown'
    end

    def get_git_remote_url
      stdout, stderr, status = Open3.capture3('git', 'config', '--get', 'remote.origin.url')
      status.success? ? stdout.strip : ''
    rescue
      ''
    end
  end
end

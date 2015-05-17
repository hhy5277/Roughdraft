require 'logger'

class GistComments
  include Enumerable

  attr_reader :page

  def each
    @list.each { |i| yield i }
  end

  def initialize(gist_id, page = 1)
    @gist_id = gist_id
    @page = page

    @list = fetch
  end

  def list
    if @list
      @list["list"]
    else
      false
    end
  end

  def links
    @list["links"]
  end

  private

    def fetch
      begin
        comments = Array.new

        github_response =Github::Gists.new(id: @gist_id).comments.all(@gist_id, client_id: Chairman.client_id, client_secret: Chairman.client_secret)

        log = Logger.new(STDOUT)
        log.info("API Ratelimit: #{github_response.headers.ratelimit_remaining}/#{github_response.headers.ratelimit_limit} (in GistComments.fetch)")

        return false if github_response.count < 1

        github_response.each do |comment|
          comment.body_rendered = pipeline(comment.body).gsub(/<pre (.+?)>\s+<code>/, '<pre \1><code>').gsub(/<\/code>\s+<\/pre>/, '</code></pre>')
          comment.created_at_formatted = Time.parse(comment.created_at).strftime("%b %-d, %Y")
          comment.user.delete_if { |key| key.to_s.match /^(.*url|id|type)$/ }
          comments << comment.to_hash
        end

        hash = {
          "list" => comments,
          "page_count" => github_response.count_pages,
          "links" => {
            "next" => github_response.links.next ? github_response.links.next.scan(/&page=(\d)/).first.first : nil,
            "prev" => github_response.links.prev ? github_response.links.prev.scan(/&page=(\d)/).first.first : nil,
          }
        }

        hash

      rescue Github::Error::NotFound
        false
      end
    end

    def pipeline(html)
      context = {
        :gfm => true,
        :asset_root => "http://#{RoughdraftApp::APP_DOMAIN}/images",
        :base_url   => "https://github.com"
      }

      pipe = HTML::Pipeline.new [
        HTML::Pipeline::MarkdownFilter,
        HTML::Pipeline::SanitizationFilter,
        HTML::Pipeline::ImageMaxWidthFilter,
        HTML::Pipeline::MentionFilter,
        HTML::Pipeline::EmojiFilter
      ], context

      pipe.call(html)[:output].to_xhtml # return XHTML to be compatible with RSS
    end
end

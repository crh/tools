#!/usr/bin/env ruby

require 'rubygems'
require 'highline/import'
require 'openssl'
require 'base64'

def get_password(prompt="Enter Master Password: ")
    ask(prompt) {|q| q.echo = false}
end

def copy_to_clipboard(content)
    case RUBY_PLATFORM
    when /darwin/
        return content if `which pbcopy`.strip == ''
        IO.popen('pbcopy', 'r+') {|foo| foo.puts content}
    when /linux/
        return content if `which xclip`.strip == ''
        IO.popen('xclip', 'r+') {|foo| foo.puts content}
    end
    content
end

unless ARGV.length == 1
    puts 'Please enter a parameter'
    exit
end

master_password = get_password();
hmac_sha1 = OpenSSL::HMAC.digest('sha1', master_password, ARGV[0])
encoded = Base64.encode64(hmac_sha1)
generated_password = encoded[0..7]
copy_to_clipboard(generated_password)

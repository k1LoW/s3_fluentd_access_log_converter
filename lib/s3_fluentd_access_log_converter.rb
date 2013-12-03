require "s3_fluentd_access_log_converter/version"
require "thor"
require 'aws-sdk'
require 'json'
require 'zlib'
require 'date'

module S3FluentdAccessLogConverter
  class CLI < Thor
    desc "get [config.yml]", "Get S3 'fluentd formatted access_log' and convert to combined access_log"
    def get(yml)
      @config = YAML.load_file(yml)
      s3 = AWS::S3.new(
                       :access_key_id => @config['aws_access_key_id'],
                       :secret_access_key => @config['aws_secret_access_key'])
      bucket = s3.buckets[@config['s3_bucket']]
      print "Get S3 logs and convert"
      Dir::mkdir(@config['log_tmp_dir']) unless Dir::exists?(@config['log_tmp_dir'])
      bucket.objects.with_prefix(@config['s3_object_prefix']).each do |object|
        unless object.key =~ /#{@config['s3_object_key_regexp']}/
          next
        end

        # Download S3 log
        File.open("#{@config['log_tmp_dir']}#{File.basename(object.key)}", 'w+') do |file|
          object.read do |chunk|
            file.write(chunk)
          end
        end

        # Open and convert
        fp = open("#{@config['log_tmp_dir']}/combined_access_log","a+")
        Zlib::GzipReader.open("#{@config['log_tmp_dir']}#{File.basename(object.key)}") do |gz|
          begin
            while l = gz.readline
              begin
                line = l.split(' ')
                timestr = line[0]
                ipstr = line[1]
                time = DateTime.parse(timestr)
                line.shift
                line.shift
                json = JSON.parse(line.join(""))
                sentense = "#{json['host']} - - [#{time.strftime("%d/%b/%Y:%H:%M:%S %Z")}] \"#{json['method']} #{json['path']} HTTP/1.1\" #{json['code']} #{json['size']} \"#{json['referer']}\" \"#{json['agent']}\"\n"
                fp.print sentense
              rescue JSON::ParserError => err
                puts "#{err} : #{l}"
              end
            end
          rescue EOFError => err
            print "."
          end
        end
        fp.close
      end
      puts "."
    end
  end
end

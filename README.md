# S3FluentdAccessLogConverter

Get S3 ``fluentd formatted apache access_log`` and convert to ``apache combined access_log``

## Installation

Add this line to your application's Gemfile:

    gem 's3_fluentd_access_log_converter', :git => "git://github.com/k1LoW/s3_fluentd_access_log_converter.git"

And then execute:

    $ bundle

## Usage

Make config.yml

    aws_access_key_id: XXXXXXXXXXXXXXXXXXXX
    aws_secret_access_key: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    s3_bucket: my-site-logs
    s3_object_prefix: httpd/
    s3_object_key_regexp: /2013\/12\/[0-9]{2}\/access_log/
    log_tmp_dir: /tmp/

And get logs

    $ s3_fluentd_access_log_converter get config.yml

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# frozen_string_literal: true

require 'rails_helper'
require 's3_helper'

describe S3Helper do
  it 'deletes temp files' do
    push

    pages_dir = Dir.glob('pages/*')
    assert(pages_dir.empty?)
  end

  it 'deletes zip file' do
    push
    assert(!File.exist?('en.zip'))
  end

  private def push
    object = double(upload_file: true)
    bucket = double(object: object)
    s3 = double(bucket: bucket)
    allow(Aws::S3::Resource).to receive(:new).and_return(s3)

    translation = Translation.find(1)
    S3Helper.push_translation(translation)
  end
end
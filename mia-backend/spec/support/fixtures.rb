def fixture_ajax_loader_path
  fixture_filepath('ajax-loader.gif')
end
def fixture_filepath(filename)
  Rails.root.join('spec','fixtures',filename)
end
def fixture_file(filename)
  File.open(fixture_filepath(filename))
end
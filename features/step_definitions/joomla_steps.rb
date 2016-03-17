Given /^there is an error requesting the joomla site$/ do
  file = File.join(Rails.root, 'features', 'support', 'backup.html')
  fake_response = File.read(file)
  FakeWeb.register_uri(:get, "http://www.natureinthecity.org/", body: fake_response, status: ["500", "SocketError"])
end
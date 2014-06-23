#
# Author:: Heavy Water Operations, LLC <support@hw-ops.com>
#
# Copyright 2014, Heavy Water Operations, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node.default[:java][:jdk_version] = 7
node.default[:java][:install_flavor] = "oracle"
node.default[:java][:oracle][:accept_oracle_download_terms] = true
node.default[:java][:ark_retries] = 5

include_recipe 'java'

cassandra_instance "dse" do
  url node['dse-cassandra-test']['url']
  checksum node['dse-cassandra-test']['checksum']
  download_prefix "/opt/cassandra/cache"
  action [:install, :enable]
end

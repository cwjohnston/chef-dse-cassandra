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

# this default will fail with a 401, you may want to override it with a url
# containing your unique Datastax Enterprise credentials
default['dse-cassandra-test']['url'] = 'https://downloads.datastax.com/enterprise/dse-4.0.3-bin.tar.gz'
default['dse-cassandra-test']['checksum'] = 'd2be416baf5ddb2cce6f3252df80de8818a5a5ab18a8cd3ece2d747ccf0150c4'

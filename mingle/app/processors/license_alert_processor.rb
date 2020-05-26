#  Copyright 2020 ThoughtWorks, Inc.
#  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#  
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/agpl-3.0.txt>.

class LicenseAlertProcessor < Messaging::Processor

  QUEUE = 'mingle.license.alert'

  def self.process(message, processor)
    processor.on_message(message)
  end

  def on_message(message)
    message = HashWithIndifferentAccess.new(message.body_hash)
    message[:alert_message] = message[:alert_message].downcase
    alert_type = "deliver_alert_for_#{message[:alert_message].gsub(' ', '_')}".to_sym

    LicenseAlertMailer.send(alert_type, message)
  end
end

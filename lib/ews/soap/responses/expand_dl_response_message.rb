=begin
  This file is part of Viewpoint; the Ruby library for Microsoft Exchange Web Services.

  Copyright © 2016 Tatiana Kudiyarova <tatiana.kudiyarova@gmail.com>

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
=end

module Viewpoint::EWS::SOAP
  class ExpandDLResponseMessage < ResponseMessage

    def success?
      response_class == "Success"
    end

    def response_class
      safe_hash_access message, [:attribs, :response_class]
    end

    def response_message_text
      safe_hash_access message, [:elems, :message_text, :text]
    end

    def distribution_group_members
      return @members if @members

      m = safe_hash_access(message, [:elems, :d_l_expansion, :elems])
      @members = m.nil? ? [] : parse_members(m)
    end

    private

    def parse_members distribution_group_members
      distribution_group_members.collect do |soap_member_resp|
        Viewpoint::EWS::Types::MailboxUser.new(ews=nil, soap_member_resp[:mailbox][:elems])
      end
    end

  end # ExpandDLResponseMessage
end # Viewpoint::EWS::SOAP
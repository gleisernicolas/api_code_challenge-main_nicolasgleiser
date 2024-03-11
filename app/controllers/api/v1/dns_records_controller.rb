module Api
  module V1
    class DnsRecordsController < ApplicationController
      # GET /dns_records
      def index
        page = query_params[:page]
        included = query_params[:included]&.split(',')
        excluded = query_params[:excluded]&.split(',')

        render json: { message: 'Page param is required' }, status: :unprocessable_entity and return if page.blank?

        render json: Dns::Hostnames.call(included, excluded, page), status: :ok
      end

      # POST /dns_records
      def create
				render json: { id: Dns::Create.call!(dns_record_params) }, status: :created
      end

      private

      def dns_record_params
        params.require(:dns_records).permit(
          :ip,
          hostnames_attributes: [:hostname]
        )
      end

      def query_params
        params.permit(:page, :included, :excluded)
      end
    end
  end
end

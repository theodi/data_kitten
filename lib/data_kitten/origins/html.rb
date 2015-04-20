module DataKitten
  
  module Origins
    
    # HTML origin module. Automatically mixed into {Dataset} for datasets that are accessed through an API.
    #
    # @see Dataset
    #
    module HTML
  
      private
  
      def self.supported?(resource)
        resource.html?
      end

      public

      # The origin type of the dataset.
      # @return [Symbol] +:html+
      # @see Dataset#origin
      def origin
        :html
      end

    end

  end

end

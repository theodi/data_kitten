module DataKitten
  module Origins
    # Git origin module. Automatically mixed into {Dataset} for datasets that are loaded from Git repositories.
    #
    # @see Dataset
    #
    module Git
      def self.supported?(resource)
        resource.to_s =~ /\A(git|https?):\/\/.*\.git\Z/
      end

      # The origin type of the dataset.
      # @return [Symbol] +:git+
      # @see Dataset#origin
      def origin
        :git
      end

      # A history of changes to the Dataset, taken from the full git changelog
      # @see Dataset#change_history
      def change_history
        @change_history ||= begin
          repository.log.map { |commit| commit }
        end
      end

      protected

      def load_file(path)
        # Make sure we have a working copy
        repository
        # read file
        File.read(File.join(working_copy_path, path))
      end

      private

      def working_copy_path
        # Create holding directory
        FileUtils.mkdir_p(File.join(File.dirname(__FILE__), "..", "..", "..", "tmp", "repositories"))
        # generate working copy dir
        File.join(File.dirname(__FILE__), "..", "..", "..", "tmp", "repositories", @access_url.tr("/", "-"))
      end

      def repository
        @repository ||= begin
          repo = ::Git.open(working_copy_path)
          repo.pull("origin", "master")
          repo
                        rescue ArgumentError
                          ::Git.clone(@access_url, working_copy_path)
        end
      end
    end
  end
end

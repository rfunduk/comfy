module Comfy
  # Comfy::View is a utility class
  class View
    include Comfy

    def self.create( path, func={}, db=Comfy::Config.db )
      raise Comfy::InvalidView unless func.is_a?( Hash )

      @db = db
      design, view = path.split( '/' )
      existing = @db.get( '_design/' + design ).to_doc
      if existing.error
        existing = Document.new( {
            '_id' => '_design/' + design,
            'views' => { view => {} }
          }, db
        )
      end

      existing.views[view]['map'] = func[:map] if func.has_key? :map
      existing.views[view]['reduce'] = func[:reduce] if func.has_key? :reduce

      existing.save
      return existing
    end

    def self.run( path, parameters={}, db=Comfy::Config.db )
      design, view = path.split( '/' )
      params = '?' + parameters.entries.collect do |key, value|
        "#{key}=#{value}"
      end.join( '&' ) if parameters.any?
      response = Response.new(
        RCW.get( "#{db.uri}/_design/#{design}/_view/" +
                 "#{view}#{params if params}" )
      )

      if response.rows
        docs = response.rows.collect do |row|
          Document.new( row['doc'] || row, db )
        end
        response.rows = docs
      end

      return response
    end

  end
end

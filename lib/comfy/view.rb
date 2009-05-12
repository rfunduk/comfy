module Comfy
  class View
    include Comfy

    def self.create( db, path, func={} )
      raise Comfy::InvalidView unless func.is_a?( Hash )

      @db = db
      design, view = path.split( '/' )
      existing = @db.get( '_design/' + design ).to_doc
      if existing.error
        existing = Document.new( @db,
          {
            '_id' => '_design/' + design,
            'views' => { view => {} }
          }
        )
      end

      existing.views[view]['map'] = func[:map] if func.has_key? :map
      existing.views[view]['reduce'] = func[:reduce] if func.has_key? :reduce

      existing.save
      return existing
    end

    def self.run( db, path, parameters={} )
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
          Document.new( db, row['doc'] || row )
        end
        response.rows = docs
      end

      return response
    end

  end
end

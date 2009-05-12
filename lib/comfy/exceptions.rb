module Comfy

  class ComfyException < StandardError;end

  class FourOhFour < ComfyException;end
  class FiveHundred < ComfyException;end
  
  class ResponseSanityFail < ComfyException;end
  class InvalidView < ComfyException;end

end

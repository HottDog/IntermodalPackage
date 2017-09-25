local newdecoder = require 'libutils.internal.libs.lunajson.decoder'
local newencoder = require 'libutils.internal.libs.lunajson.encoder'
local sax = require 'libutils.internal.libs.lunajson.sax'
-- If you need multiple contexts of decoder and/or encoder,
-- you can require lunajson.decoder and/or lunajson.encoder directly.
return {
	decode = newdecoder(),
	encode = newencoder(),
	newparser = sax.newparser,
	newfileparser = sax.newfileparser,
}

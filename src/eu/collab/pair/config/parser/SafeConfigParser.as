/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.config.parser
{
	public class SafeConfigParser extends ConfigParser
	{
		public function SafeConfigParser(defaults:*, dictType:*)
		{
			super(defaults, dictType);
		}
		
		/*
		
		def _interpolate(self, section, option, rawval, vars):
        # do the string interpolation
        L = []
        self._interpolate_some(option, L, rawval, section, vars, 1)
        return ''.join(L)

    _interpvar_re = re.compile(r"%\(([^)]+)\)s")
    _badpercent_re = re.compile(r"%[^%]|%$")

    def _interpolate_some(self, option, accum, rest, section, map, depth):
        if depth > MAX_INTERPOLATION_DEPTH:
            raise InterpolationDepthError(option, section, rest)
        while rest:
            p = rest.find("%")
            if p < 0:
                accum.append(rest)
                return
            if p > 0:
                accum.append(rest[:p])
                rest = rest[p:]
            # p is no longer used
            c = rest[1:2]
            if c == "%":
                accum.append("%")
                rest = rest[2:]
            elif c == "(":
                m = self._interpvar_re.match(rest)
                if m is None:
                    raise InterpolationSyntaxError(option, section,
                        "bad interpolation variable reference %r" % rest)
                var = self.optionxform(m.group(1))
                rest = rest[m.end():]
                try:
                    v = map[var]
                except KeyError:
                    raise InterpolationMissingOptionError(
                        option, section, rest, var)
                if "%" in v:
                    self._interpolate_some(option, accum, v,
                                           section, map, depth + 1)
                else:
                    accum.append(v)
            else:
                raise InterpolationSyntaxError(
                    option, section,
                    "'%%' must be followed by '%%' or '(', found: %r" % (rest,))

    def set(self, section, option, value):
        """Set an option.  Extend ConfigParser.set: check for string values."""
        if not isinstance(value, basestring):
            raise TypeError("option values must be strings")
        # check for bad percent signs:
        # first, replace all "good" interpolations
        tmp_value = self._interpvar_re.sub('', value)
        # then, check if there's a lone percent sign left
        m = self._badpercent_re.search(tmp_value)
        if m:
            raise ValueError("invalid interpolation syntax in %r at "
                             "position %d" % (value, m.start()))
        ConfigParser.set(self, section, option, value)
        
        */
		
	}
}
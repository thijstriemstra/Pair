/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.config.parser
{
	import flash.utils.Dictionary;
	
	public class RawConfigParser
	{
		private var _dict:*;
		private var _sections:*;
		private var _defaults:*;
		
		public function RawConfigParser(defaults:*, dictType:*)
		{
			if (dictType is Dictionary) {
				this._dict = Dictionary;
			}
			this._sections = this._dict();
        	this._defaults = this._dict();
        
			if (defaults) {
				// for key, value in defaults.items():
                //      self._defaults[self.optionxform(key)] = value
			}
		}
		
		public function get defaults():Dictionary
		{
			return this._defaults;
		}
		
		public function get sections():Dictionary
		{
			return this._sections; //.keys()
		}
		
		/**
		 * Create a new section in the configuration.
		 * 
		 * Raise DuplicateSectionError if a section by the specified name
         * already exists. Raise TypeError if name is DEFAULT or any of it's
         * case-insensitive variants.
         * 
		 * @param section
		 */		
		public function addSection(section:String):void
		{
			if (section.toLowerCase() == "default") {
				throw new TypeError('Invalid section name: ' + section);
			}
			
			if (this.hasSection(section)) {
            	throw new DuplicateSectionError(section);
   			}
   			
   			this._sections[section] = this._dict();
		}
		
		/**
		 * Indicate whether the named section is present in the configuration.
		 * 
		 * The DEFAULT section is not acknowledged.
		 * 
		 * @param section
		 * @return Boolean
		 */		
		public function hasSection(section:String):Boolean
		{
			var found:Boolean = false;
			for (var s:int=0;s<this._sections.length;s++) {
				if (this._sections[s] == section) {
					found = true;
					break;
				}
			}
			
			return found;
		}
		
		/**
		 * Return a list of option names for the given section name.
		 *  
		 * @param section
		 * @return 
		 */		
		public function options(section:String):Array
		{
			try
			{
	            opts = this._sections[section].copy();
	  		}
	        catch (err:*)
	        {
	        	throw new NoSectionError(section);
	        }
	        
	        opts.update(this._defaults)
	        
	        if ('__name__' in opts) {
	            delete opts['__name__'];
	        }
	            
	        return opts.keys();
		}
		
		/**
		 * Read and parse a filename or a list of filenames.
		 *
         * Files that cannot be opened are silently ignored; this is
         * designed so that you can specify a list of potential
         * configuration file locations (e.g. current directory, user's
         * home directory, systemwide directory), and all existing
         * configuration files in the list will be read.  A single
         * filename may also be given.
		 *
		 * @param filenames 
		 * @return list of successfully read files.
		 * 
		 */		
		public function read(filenames:*):Array
		{
			var read_ok:Array = [];
			
	        if (filenames is String) {
	            filenames = [filenames];
	        }
	        
	        for (var filename:String in filenames) {
	            try
				{
	                // fp = open(filename)
	   			}
	            catch (e:*)
	            {
	                continue;
	            }
	            self._read(fp, filename)
	            fp.close()
	            read_ok.append(filename)
	        }
	        
	        return read_ok
	 	}
	 	
	 	/**
	 	 * Like read() but the argument must be a file-like object.
	 	 * 
	 	 * The `fp' argument must have a `readline' method.  Optional
	 	 * second argument is the `filename', which if not given, is
	 	 * taken from fp.name.  If fp has no `name' attribute, `<???>' is
	 	 * used.
	 	 * 
	 	 * @param fp
	 	 * @param filename
	 	 * @return 
	 	 */	 	
	 	public function readfp(fp:*, filename:*=undefined):Array
	 	{
	 		if (filename == undefined)
	 		{
	            try
	            {
	                filename = fp.name;
	            }
	            catch (e:*)
	            {
	                filename = '<???>';
	   			}
	   		}
	   		
        	//this._read(fp, filename)
	 	}
	 	
	 	/*
	 	
	 	def get(self, section, option):
        opt = self.optionxform(option)
        if section not in self._sections:
            if section != DEFAULTSECT:
                raise NoSectionError(section)
            if opt in self._defaults:
                return self._defaults[opt]
            else:
                raise NoOptionError(option, section)
        elif opt in self._sections[section]:
            return self._sections[section][opt]
        elif opt in self._defaults:
            return self._defaults[opt]
        else:
            raise NoOptionError(option, section)

    def items(self, section):
        try:
            d2 = self._sections[section]
        except KeyError:
            if section != DEFAULTSECT:
                raise NoSectionError(section)
            d2 = self._dict()
        d = self._defaults.copy()
        d.update(d2)
        if "__name__" in d:
            del d["__name__"]
        return d.items()

    def _get(self, section, conv, option):
        return conv(self.get(section, option))

    def getint(self, section, option):
        return self._get(section, int, option)

    def getfloat(self, section, option):
        return self._get(section, float, option)

    _boolean_states = {'1': True, 'yes': True, 'true': True, 'on': True,
                       '0': False, 'no': False, 'false': False, 'off': False}

    def getboolean(self, section, option):
        v = self.get(section, option)
        if v.lower() not in self._boolean_states:
            raise ValueError, 'Not a boolean: %s' % v
        return self._boolean_states[v.lower()]

    def optionxform(self, optionstr):
        return optionstr.lower()

    def has_option(self, section, option):
        """Check for the existence of a given option in a given section."""
        if not section or section == DEFAULTSECT:
            option = self.optionxform(option)
            return option in self._defaults
        elif section not in self._sections:
            return False
        else:
            option = self.optionxform(option)
            return (option in self._sections[section]
                    or option in self._defaults)

    def set(self, section, option, value):
        """Set an option."""
        if not section or section == DEFAULTSECT:
            sectdict = self._defaults
        else:
            try:
                sectdict = self._sections[section]
            except KeyError:
                raise NoSectionError(section)
        sectdict[self.optionxform(option)] = value

    def write(self, fp):
        """Write an .ini-format representation of the configuration state."""
        if self._defaults:
            fp.write("[%s]\n" % DEFAULTSECT)
            for (key, value) in self._defaults.items():
                fp.write("%s = %s\n" % (key, str(value).replace('\n', '\n\t')))
            fp.write("\n")
        for section in self._sections:
            fp.write("[%s]\n" % section)
            for (key, value) in self._sections[section].items():
                if key != "__name__":
                    fp.write("%s = %s\n" %
                             (key, str(value).replace('\n', '\n\t')))
            fp.write("\n")

    def remove_option(self, section, option):
        """Remove an option."""
        if not section or section == DEFAULTSECT:
            sectdict = self._defaults
        else:
            try:
                sectdict = self._sections[section]
            except KeyError:
                raise NoSectionError(section)
        option = self.optionxform(option)
        existed = option in sectdict
        if existed:
            del sectdict[option]
        return existed

    def remove_section(self, section):
        """Remove a file section."""
        existed = section in self._sections
        if existed:
            del self._sections[section]
        return existed

    #
    # Regular expressions for parsing section headers and options.
    #
    SECTCRE = re.compile(
        r'\['                                 # [
        r'(?P<header>[^]]+)'                  # very permissive!
        r'\]'                                 # ]
        )
    OPTCRE = re.compile(
        r'(?P<option>[^:=\s][^:=]*)'          # very permissive!
        r'\s*(?P<vi>[:=])\s*'                 # any number of space/tab,
                                              # followed by separator
                                              # (either : or =), followed
                                              # by any # space/tab
        r'(?P<value>.*)$'                     # everything up to eol
        )

    def _read(self, fp, fpname):
        """Parse a sectioned setup file.

        The sections in setup file contains a title line at the top,
        indicated by a name in square brackets (`[]'), plus key/value
        options lines, indicated by `name: value' format lines.
        Continuations are represented by an embedded newline then
        leading whitespace.  Blank lines, lines beginning with a '#',
        and just about everything else are ignored.
        """
        cursect = None                            # None, or a dictionary
        optname = None
        lineno = 0
        e = None                                  # None, or an exception
        while True:
            line = fp.readline()
            if not line:
                break
            lineno = lineno + 1
            # comment or blank line?
            if line.strip() == '' or line[0] in '#;':
                continue
            if line.split(None, 1)[0].lower() == 'rem' and line[0] in "rR":
                # no leading whitespace
                continue
            # continuation line?
            if line[0].isspace() and cursect is not None and optname:
                value = line.strip()
                if value:
                    cursect[optname] = "%s\n%s" % (cursect[optname], value)
            # a section header or option header?
            else:
                # is it a section header?
                mo = self.SECTCRE.match(line)
                if mo:
                    sectname = mo.group('header')
                    if sectname in self._sections:
                        cursect = self._sections[sectname]
                    elif sectname == DEFAULTSECT:
                        cursect = self._defaults
                    else:
                        cursect = self._dict()
                        cursect['__name__'] = sectname
                        self._sections[sectname] = cursect
                    # So sections can't start with a continuation line
                    optname = None
                # no section header in the file?
                elif cursect is None:
                    raise MissingSectionHeaderError(fpname, lineno, line)
                # an option line?
                else:
                    mo = self.OPTCRE.match(line)
                    if mo:
                        optname, vi, optval = mo.group('option', 'vi', 'value')
                        if vi in ('=', ':') and ';' in optval:
                            # ';' is a comment delimiter only if it follows
                            # a spacing character
                            pos = optval.find(';')
                            if pos != -1 and optval[pos-1].isspace():
                                optval = optval[:pos]
                        optval = optval.strip()
                        # allow empty values
                        if optval == '""':
                            optval = ''
                        optname = self.optionxform(optname.rstrip())
                        cursect[optname] = optval
                    else:
                        # a non-fatal parsing error occurred.  set up the
                        # exception but keep going. the exception will be
                        # raised at the end of the file and will contain a
                        # list of all bogus lines
                        if not e:
                            e = ParsingError(fpname)
                        e.append(lineno, repr(line))
        # if any parsing errors occurred, raise an exception
        if e:
            raise e
            
        */

	}
}
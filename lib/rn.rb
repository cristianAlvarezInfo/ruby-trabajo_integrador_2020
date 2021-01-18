module RN
  autoload :VERSION, 'rn/version'
  autoload :Commands, 'rn/commands'
  autoload :PathResolver,  'helpers/helpers'
  autoload :Validator,  'helpers/helpers'
  autoload :Book,  'models/book'
  autoload :Note,  'models/note'
  # Agregar aquí cualquier autoload que sea necesario para que se cargue las clases y
  # módulos del modelo de datos.
  # Por ejemplo:
  # autoload :Note, 'rn/note'
end

{; Cargar nueva escena que se encuentra en la carpeta escenas
 ; Si existe una funcion init en la escene lo ejecuta 
 :load (fn [name ...]
         (let [scene (require (.. :scene. name))]
           (when scene.init (scene.init ...))
           scene))}

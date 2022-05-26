//
//  ViewController.swift
//  coreDataProject
//
//  Created by wendy manrique on 25/05/22.
//

import UIKit
//1.Importar libreria coredata
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //2.Referencia al managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext
    
    //3.Cambiar a variables de tipo pais sin datos inciales
    private var myCountries:[Pais]?
    // private let myCountries = ["España", "Mexico", "Perú", "Colombia", "Argentina", "EEUU", "Francia", "Italia"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //4.Recuperar datos
       recuperarDatos()
    }

    @IBAction func add(_ sender: Any) {
        //print("Añadir datos")
        
        //CREAR ALERTA
        let alert = UIAlertController(title: "Agregar Pais", message: "Añade un pais nuevo", preferredStyle: .alert)
        alert.addTextField() //Con este codigo se podra agregar el nombre de los paises
        
        //CREAR Y CONFIGURAR BOTON DE ALERTA
        let botonAlerta = UIAlertAction(title: "Añadir", style: .default){ (action) in
            
            //RECUPERAR TEXTFIELD DE LA ALERTA (AÑADIR LOS PAISES)
            let textField = alert.textFields![0]
            
            //CREAR OBJETO PAIS
            let nuevoPais = Pais(context: self.context)
            nuevoPais.nombre = textField.text
            
            //GUARDAR INFORMACION (Añade block do-try-catch)
            try! self.context.save()
            
            //REFRESCAR INFORMACION EN TABLEVIEW
            self.recuperarDatos()
        }
        
        //AÑADIR BOTON A LA ALERTA Y MOSTRAR LA ALERTA
        alert.addAction(botonAlerta)
        self.present(alert, animated: true,completion: nil)
    }
    
    //SE CREO LA FUNCION RECUPERAR DATOS
    //NOTA: El fetchRequest se obtiene de la clase Pais+CoreDataProperties
    func recuperarDatos(){
        do {
            self.myCountries = try context.fetch(Pais.fetchRequest())
            
            //DispatchQueue es para que el hilo principal de la aplicacion se encargue de mostrar los datos en el TableView
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        catch{
            print("Error recuperando datos")
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //5.Se le agrego un ! a myCountries para contar cuantos paises tiene
        return myCountries?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            var cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
            if cell == nil {
               
                cell = UITableViewCell(style: .default, reuseIdentifier: "mycell")
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 20)
                
            }
        
        //5.Se le agrego un ! a myCountries y un .nombre para recuperar los nombres de los paises y te lo asignara a cell que es la celda
        cell!.textLabel?.text = myCountries![indexPath.row].nombre
            return cell!
      
    }
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    //5.Se le agrego un ! a myCountries
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(myCountries![indexPath.row])
        
        //7.Añadir funcionalidad de editar
        
        //Cual pais se editara?
        let paisEditar = self.myCountries![indexPath.row]
        
        //Crear alerta
        let alert = UIAlertController(title: "Editar pais", message: "Editar pais", preferredStyle: .alert)
        alert.addTextField()
        
        //Recuperar nombre de pais actual de la tabla y agregarla al textField de la alerta
        let textField = alert.textFields![0]
        textField.text = paisEditar.nombre
        
        //Crear y configurar boton de alerta
        let botonAlerta = UIAlertAction(title: "Editar", style: .default) { (action) in
            
            //Recuperar textField de la alerta
            let textField = alert.textFields![0]
            
            //Editar pais actual con lo que este en el textfield
            paisEditar.nombre = textField.text
            
            //Guardar informacion (añade block do-try-catch)
            try! self.context.save()
            
            //Refrescar informacion en tableView
            self.recuperarDatos()
        }
        //Añadir boton de la alerta y mostrar la alerta
        alert.addAction(botonAlerta)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //6.Añadir funcionalidad de swipe para eliminar
   //NOTA:trailingSwipeActionsConfigurationForRowAt se encargara de eliminar al hacer swipe a la izquiera de algun nombre de pais
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //Crear accion de eliminar
        let accionEliminar = UIContextualAction(style: .destructive, title: "Eliminar") { (action,view,completionHandler) in
            
            //Cual pais eliminar?
            let paisEliminar = self.myCountries![indexPath.row]
            
            //Eliminar pais
            self.context.delete(paisEliminar)
            
            //Guardar el cambio de informacion
            try! self.context.save()
            
            //Recargar datos
            self.recuperarDatos()
        }
        return UISwipeActionsConfiguration(actions: [accionEliminar])
        
    }
}


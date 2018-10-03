package uniandes.isis2304.superAndes.persistencia;

import java.util.List;

import javax.jdo.PersistenceManagerFactory;

import org.apache.log4j.Logger;

public class PersistenciaSuperAndes {
	/* ****************************************************************
	 * 			Constantes
	 *****************************************************************/
	/**
	 * Logger para escribir la traza de la ejecución.
	 */
	private static Logger log = Logger.getLogger(PersistenciaSuperAndes.class.getName());
	/**
	 * Cadena para indicar el tipo de sentencias que se va a utilizar en una consulta.
	 */
	public final static String SQL = "javax.jdo.query.SQL";
	
	/**
	 * Atributo privado que es el único objeto de la clase.
	 */
	private static PersistenciaSuperAndes instance;
	/**
	 * Fábrica de manejadores de la persistencia. Para el manejo correcto de las transacciones.
	 */
	private PersistenceManagerFactory pmf;
	/**
	 * Arreglo de cadenas con los nombres de las tablas de la base de datos, en su orden:
	 * 
	 */
	private List<String> tablas;

}

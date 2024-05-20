/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package simple;


public class automatedOrder {
    private String prod_inv_name, prod_inv_quantity_type;
    private int av_quantity;
    
    public automatedOrder(String prod_inv_name, int av_quantity, String prod_inv_quantity_type){
        this.prod_inv_name = prod_inv_name;
        this.av_quantity = av_quantity;
        this.prod_inv_quantity_type = prod_inv_quantity_type;
    }
    public String getprod_inv_name(){
        return prod_inv_name;
    }
    public int getav_quantity(){
        return av_quantity;
    }
    public String getprod_inv_quantity_type(){
        return prod_inv_quantity_type;
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package simple;

public class log_delete {
    private int log_del_id;
    private String log_del_action, log_del_table, log_del_value, log_del_change_time;
    
    public log_delete(int log_del_id, String log_del_action, String log_del_table, String log_del_value, String log_del_change_time){
        this.log_del_id = log_del_id;
        this.log_del_action = log_del_action;
        this.log_del_table = log_del_table;
        this.log_del_value = log_del_value;
        this.log_del_change_time = log_del_change_time;
    }
    public int getlog_del_id(){
        return log_del_id;
    }
    public String getlog_del_action(){
        return log_del_action;
    }
    public String getlog_del_table(){
        return log_del_table;
    }
    public String getlog_del_value(){
        return log_del_value;
    }
    public String getlog_del_change_time(){
        return log_del_change_time;
    }
}

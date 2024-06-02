/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package simple;

public class log_update {
    private int log_up_id;
    private String log_up_action, log_up_table, log_up_col_name, log_up_pk_value, log_up_old_value, log_up_new_value, log_up_change_time;
    
    public log_update(int log_up_id, String log_up_action, String log_up_table, String log_up_col_name, String log_up_pk_value, String log_up_old_value, String log_up_new_value, String log_up_change_time){
        this.log_up_id = log_up_id;
        this.log_up_action = log_up_action;
        this.log_up_table = log_up_table;
        this.log_up_col_name = log_up_col_name;
        this.log_up_pk_value = log_up_pk_value;
        this.log_up_old_value = log_up_old_value;
        this.log_up_new_value = log_up_new_value;
        this.log_up_change_time = log_up_change_time;
    }
    public int getlog_up_id(){
        return log_up_id;
    }
    public String getlog_up_action(){
        return log_up_action;
    }
    public String getlog_up_table(){
        return log_up_table;
    }
    public String getlog_up_col_name(){
        return log_up_col_name;
    }
    public String getlog_up_pk_value(){
        return log_up_pk_value;
    }
    public String getlog_up_old_value(){
        return log_up_old_value;
    }
    public String getlog_up_new_value(){
        return log_up_new_value;
    }
    public String getlog_up_change_time(){
        return log_up_change_time;
    }
}

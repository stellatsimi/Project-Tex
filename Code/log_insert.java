/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package simple;

/**
 *
 * @author USER
 */
class log_insert {
    private int log_ins_id;
    private String log_ins_action, log_ins_table, log_ins_new_record, log_ins_change_time;
    
    public log_insert(int log_ins_id, String log_ins_action, String log_ins_table, String log_ins_new_record, String log_ins_change_time){
        this.log_ins_id = log_ins_id;
        this.log_ins_action = log_ins_action;
        this.log_ins_table = log_ins_table;
        this.log_ins_new_record = log_ins_new_record;
        this.log_ins_change_time = log_ins_change_time;
    }
    public int getlog_ins_id(){
        return log_ins_id;
    }
    public String getlog_ins_action(){
        return log_ins_action;
    }
    public String getlog_ins_table(){
        return log_ins_table;
    }
    public String getlog_ins_new_record(){
        return log_ins_new_record;
    }
    public String getlog_ins_change_time(){
        return log_ins_change_time;
    }
}

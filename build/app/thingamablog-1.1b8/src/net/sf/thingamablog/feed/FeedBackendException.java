/*
 * Created on Apr 30, 2004
 *  
 * This file is part of Thingamablog. ( http://thingamablog.sf.net )
 *
 * Copyright (c) 2004, Bob Tantlinger All Rights Reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
 * USA.
 */
package net.sf.thingamablog.feed;

/**
 * Signals that a FeedBackendException of some sort occured
 * 
 * @author Bob Tantlinger
 *
 */
public class FeedBackendException extends Exception
{

    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    /**
     * Constructs a FeedBackendException
     */
    public FeedBackendException()
    {
        super();        
    }

    /**
     * Constructs a FeedBackendException 
     * @param message The message
     */
    public FeedBackendException(String message)
    {
        super(message);        
    }

    /**
     * Constructs a FeedBackendException
     * 
     * @param message The message
     * @param cause The cause
     */
    public FeedBackendException(String message, Throwable cause)
    {
        super(message, cause);        
    }

    /**
     * Constructs a FeedBackendException
     * 
     * @param cause The cause
     */
    public FeedBackendException(Throwable cause)
    {
        super(cause);        
    }

}

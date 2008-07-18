;;; rails-project.el --- support per rails project settings

;; Copyright (C) 2006 Dmitry Galinsky <dima dot exe at gmail dot com>

;; Authors: Dmitry Galinsky <dima dot exe at gmail dot com>,

;; Keywords: ruby rails languages
;; $URL: svn+ssh://rubyforge.org/var/svn/emacs-rails/trunk/rails.el $
;; $Id: rails.el 225 2008-03-02 21:07:10Z dimaexe $

;;; License

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

;;; Code:

(require 'cl)
(require 'rails-lib)

(defcustom rails/project/config "config/config.el"
  "The file name to store per project settings."
  :group 'rails
  :type 'string)

(defun rails/project/apply (root buffer config)
  (with-current-buffer buffer
    (when-bind (root (rails/root))
      (mapc
       '(lambda(i)
          (set (make-local-variable (car i)) (cdr i)))
       config))))

(defun rails/project/edit (&optional root)
  (interactive)
  (unless root
    (setq root (rails/root)))
  (when root
    (rails/find-file root rails/project/config)
    (add-hook 'after-save-hook 'rails/project/update t t)))

(defun rails/project/update (&optional root)
  (interactive)
  (unless root
    (setq root (rails/root)))
  (when root
    (when-bind (config (rails/project/read-config root))
      (mapc
       '(lambda (buf)
          (rails/project/apply root buf config))
       (buffer-list))
      (rails/reload-bundles))))

(defun rails/project/read-config (root)
  (when (rails/file-exist-p root rails/project/config)
    (let ((config (files-ext/read-from-file
                   (concat root rails/project/config))))
      (when (listp config)
        config))))

;;(rails/project/read-config "~/Sites/pro2/")
(provide 'rails-project)
